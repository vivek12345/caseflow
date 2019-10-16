# frozen_string_literal: true

shared_context "AMA Tableau SQL", shared_context: :metadata do
  let!(:staff) { create(:staff, :attorney_judge_role) }
  let(:user) do
    CachedUser.sync_from_vacols
    user = create(:user, css_id: CachedUser.first.sdomainid)
    allow(user).to receive(:judge_in_vacols?) { true }
    user
  end
  let!(:aod_person) { create(:person, date_of_birth: 76.years.ago, participant_id: aod_veteran.participant_id) }
  let!(:person) { create(:person, date_of_birth: 65.years.ago, participant_id: veteran.participant_id) }
  let(:aod_veteran) { create(:veteran) }
  let(:veteran) { create(:veteran) }
  let!(:not_distributed) do
    create(:appeal, :ready_for_distribution, veteran_file_number: veteran.file_number)
  end
  let!(:not_distributed_with_timed_hold) do
    create(:appeal, :ready_for_distribution, veteran_file_number: aod_veteran.file_number).tap do |appeal|
      create(:timed_hold_task, appeal: appeal, parent: appeal.root_task)
    end
  end
  let!(:distributed_to_judge) { create(:appeal, :assigned_to_judge) }
  let!(:assigned_to_attorney) do
    create(:appeal).tap do |appeal|
      root_task = create(:root_task, appeal: appeal)
      create(:ama_attorney_task, appeal: appeal, parent: root_task)
    end
  end
  let!(:assigned_to_colocated) do
    create(:appeal).tap do |appeal|
      root_task = create(:root_task, appeal: appeal)
      create(:ama_colocated_task, appeal: appeal, assigned_to: user, parent: root_task)
    end
  end
  let!(:decision_in_progress) do
    create(:appeal).tap do |appeal|
      create(:root_task, appeal: appeal)
      create(:ama_attorney_task, :in_progress, appeal: appeal, assigned_by: user, parent: appeal.root_task)
    end
  end
  let!(:decision_ready_for_signature) do
    create(:appeal).tap do |appeal|
      root_task = create(:root_task, appeal: appeal)
      create(:ama_judge_decision_review_task, :in_progress, appeal: appeal, parent: root_task)
    end
  end
  let!(:decision_signed) do
    create(:appeal).tap do |appeal|
      root_task = create(:root_task, appeal: appeal)
      create(:bva_dispatch_task, :in_progress, appeal: appeal, parent: root_task)
    end
  end
  let!(:decision_dispatched) do
    create(:appeal).tap do |appeal|
      root_task = create(:root_task, appeal: appeal)
      create(:bva_dispatch_task, :completed, appeal: appeal, parent: root_task)
      root_task.completed!
    end
  end
  let!(:dispatched_with_subsequent_assigned_task) do
    create(:appeal).tap do |appeal|
      root_task = create(:root_task, appeal: appeal)
      create(:bva_dispatch_task, :completed, appeal: appeal, parent: root_task)
      create(:ama_attorney_task, assigned_to: user, appeal: appeal, parent: root_task)
    end
  end
  let!(:cancelled) do
    create(:appeal).tap do |appeal|
      create(:root_task, :cancelled, appeal: appeal)
    end
  end
  let!(:on_hold) do
    create(:appeal).tap do |appeal|
      root_task = create(:root_task, appeal: appeal)
      create(:timed_hold_task, appeal: appeal, parent: root_task)
    end
  end
  let!(:misc) do
    create(:appeal).tap do |appeal|
      root_task = create(:root_task, appeal: appeal)
      create(:ama_judge_dispatch_return_task, appeal: appeal, parent: root_task)
    end
  end

  let(:expected_report) do
    {
      not_distributed.id => "1. Not distributed",
      not_distributed_with_timed_hold.id => "ON HOLD",
      distributed_to_judge.id => "2. Distributed to judge",
      assigned_to_attorney.id => "3. Assigned to attorney",
      dispatched_with_subsequent_assigned_task.id => "3. Assigned to attorney",
      assigned_to_colocated.id => "4. Assigned to colocated",
      decision_in_progress.id => "5. Decision in progress",
      decision_ready_for_signature.id => "6. Decision ready for signature",
      decision_signed.id => "7. Decision signed",
      decision_dispatched.id => "8. Decision dispatched",
      cancelled.id => "CANCELLED",
      on_hold.id => "ON HOLD",
      misc.id => "MISC"
    }
  end
end
