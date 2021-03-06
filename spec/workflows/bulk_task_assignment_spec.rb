# frozen_string_literal: true

describe BulkTaskAssignment, :postgres do
  describe "#process" do
    let(:organization) { HearingsManagement.singleton }
    let!(:no_show_hearing_task1) do
      create(
        :no_show_hearing_task,
        assigned_to: organization,
        created_at: 5.days.ago
      )
    end
    let!(:no_show_hearing_task2) do
      create(:no_show_hearing_task,
             assigned_to: organization,
             created_at: 2.days.ago)
    end
    let!(:no_show_hearing_task3) do
      create(:no_show_hearing_task,
             assigned_to: organization,
             created_at: 1.day.ago)
    end

    # Even it is the oldest task, it should skip it becasue it is on hold
    let!(:no_show_hearing_task4) do
      create(:no_show_hearing_task,
             :on_hold,
             assigned_to: organization,
             created_at: 6.days.ago)
    end

    let(:assigned_to) { create(:user) }
    let(:assigned_by) { create(:user) }

    let(:params) do
      {
        assigned_to_id: assigned_to_param.id,
        assigned_by: assigned_by_param,
        organization_url: organization_url,
        task_type: task_type,
        task_count: task_count,
        regional_office: regional_office
      }
    end
    let(:task_type) { "NoShowHearingTask" }
    let(:organization_url) { organization.url }
    let(:task_count) { 2 }
    let(:regional_office) { nil }
    let(:assigned_by_param) { assigned_by }
    let(:assigned_to_param) { assigned_to }

    before do
      OrganizationsUser.make_user_admin(assigned_by, organization)
      organization.users << assigned_to
    end

    shared_examples "invalid bulk assign" do
      it "does not bulk assigns tasks" do
        bulk_assignment = BulkTaskAssignment.new(params)
        expect(bulk_assignment.valid?).to eq false
        expect(bulk_assignment.errors[error_sym]).to eq [error]
      end
    end

    shared_examples "valid bulk assign" do
      it "bulk assigns tasks" do
        count_before = Task.count
        bulk_assignment = BulkTaskAssignment.new(params)
        expect(bulk_assignment.valid?).to eq true
        result = bulk_assignment.process
        expect(Task.count).to eq count_before + 2
        expect(result.count).to eq 2
        expect(result.first.assigned_to).to eq assigned_to
        expect(result.first.type).to eq "NoShowHearingTask"
        expect(result.first.assigned_by).to eq assigned_by
        expect(result.first.appeal).to eq no_show_hearing_task1.appeal
        expect(result.first.parent_id).to eq no_show_hearing_task1.id
      end
    end

    context "when assigned to user does not belong to organization" do
      let(:assigned_to_param) { create(:user) }
      let(:error) { "does not belong to organization with url #{organization.url}" }
      let(:error_sym) { :assigned_to }

      it_behaves_like "invalid bulk assign"
    end

    context "when assigned by user is not admin of organization" do
      let(:assigned_by_param) { create(:user) }
      let(:error) { "is not admin of organization with url #{organization.url}" }
      let(:error_sym) { :assigned_by }

      it_behaves_like "invalid bulk assign"
    end

    context "when regional office is not valid" do
      let(:regional_office) { "Not Valid" }
      let(:error) { "could not find regional office: #{regional_office}" }
      let(:error_sym) { :regional_office }

      it_behaves_like "invalid bulk assign"
    end

    context "when task type is not valid" do
      let(:task_type) { "UnknownTaskType" }
      let(:error) { "#{task_type} is not a valid task type" }
      let(:error_sym) { :task_type }

      it_behaves_like "invalid bulk assign"
    end

    context "when organization is not valid" do
      let(:organization_url) { 1234 }
      let(:error) { "could not find an organization with url #{organization_url}" }
      let(:error_sym) { :organization_url }

      it_behaves_like "invalid bulk assign"
    end

    context "when organization cannot bulk assign" do
      let(:organization_url) { create(:organization).url }
      let(:error) { "with url #{organization_url} cannot bulk assign tasks" }
      let(:error_sym) { :organization }

      it_behaves_like "invalid bulk assign"
    end

    context "when all attributes are present" do
      it_behaves_like "valid bulk assign"

      context "when the org is not hearings management" do
        context "when the org is the mail team" do
          let(:organization) { MailTeam.singleton }

          it_behaves_like "valid bulk assign"
        end

        context "when the org is a vso" do
          let(:organization) { create(:vso, name: "VSO that cannot bulk assign") }
          let(:error) { "with url #{organization_url} cannot bulk assign tasks" }
          let(:error_sym) { :organization }

          it_behaves_like "invalid bulk assign"

          context "when the vso is American Legion" do
            let(:organization) { create(:vso, name: "American Legion") }

            it_behaves_like "valid bulk assign"
          end
        end
      end

      context "when there are legacy appeals and regional office is passed" do
        let(:regional_office) { "RO17" }
        let(:legacy_appeal) { create(:legacy_appeal, closest_regional_office: regional_office) }
        let!(:no_show_hearing_task_with_legacy_appeal) do
          create(:no_show_hearing_task,
                 appeal: legacy_appeal,
                 assigned_to: organization,
                 created_at: 2.days.ago)
        end

        it "filters by regional office" do
          no_show_hearing_task2.appeal.update(closest_regional_office: regional_office)
          no_show_hearing_task3.appeal.update(closest_regional_office: "RO19")
          count_before = Task.count
          bulk_assignment = BulkTaskAssignment.new(params)
          expect(bulk_assignment.valid?).to eq true
          result = bulk_assignment.process
          expect(Task.count).to eq count_before + 2
          expect(result.count).to eq 2
          task_with_ama_appeal = result.find { |task| task.appeal == no_show_hearing_task2.appeal }
          expect(task_with_ama_appeal.assigned_to).to eq assigned_to
          expect(task_with_ama_appeal.type).to eq "NoShowHearingTask"
          expect(task_with_ama_appeal.assigned_by).to eq assigned_by
          expect(task_with_ama_appeal.parent_id).to eq no_show_hearing_task2.id

          task_with_legacy_appeal = result.find { |task| task.appeal == legacy_appeal }
          expect(task_with_legacy_appeal.assigned_to).to eq assigned_to
          expect(task_with_legacy_appeal.type).to eq "NoShowHearingTask"
          expect(task_with_legacy_appeal.assigned_by).to eq assigned_by
        end
      end
    end
  end
end
