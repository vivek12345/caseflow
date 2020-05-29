# frozen_string_literal: true

class OnHoldTasksTab < QueueTab
  validate :assignee_is_user

  def label
    COPY::QUEUE_PAGE_ON_HOLD_TAB_TITLE
  end

  def self.tab_name
    Constants.QUEUE_CONFIG.INDIVIDUALLY_ON_HOLD_TASKS_TAB_NAME
  end

  def description
    COPY::USER_QUEUE_PAGE_ON_HOLD_TASKS_DESCRIPTION
  end

  def tasks
    task_ids = ama_task_ids

    if assignee.can_create_legacy_colocated_tasks?
      task_ids.concat(legacy_colocated_task_ids_assigned_by_assignee)
    end

    Task.includes(*task_includes).where(id: task_ids)
  end

  def ama_task_ids
    Task.visible_in_queue_table_view.on_hold.where(assigned_to: assignee).pluck(:id)
  end

  def legacy_colocated_task_ids_assigned_by_assignee
    colocated_tasks = ColocatedTask.open.order(:created_at)
      .where(assigned_by: assignee, assigned_to_type: Organization.name, appeal_type: LegacyAppeal.name)

    colocated_tasks.group_by(&:appeal_id).map { |_appeal_id, tasks| tasks.first.id }
  end

  # rubocop:disable Metrics/AbcSize
  def column_names
    return QueueTab.attorney_column_names if assignee.attorney_in_vacols?

    [
      Constants.QUEUE_CONFIG.COLUMNS.BADGES.name,
      Constants.QUEUE_CONFIG.COLUMNS.CASE_DETAILS_LINK.name,
      Constants.QUEUE_CONFIG.COLUMNS.TASK_TYPE.name,
      show_regional_office_column ? Constants.QUEUE_CONFIG.COLUMNS.REGIONAL_OFFICE.name : nil,
      Constants.QUEUE_CONFIG.COLUMNS.APPEAL_TYPE.name,
      Constants.QUEUE_CONFIG.COLUMNS.DOCKET_NUMBER.name,
      Constants.QUEUE_CONFIG.COLUMNS.DAYS_ON_HOLD.name,
      Constants.QUEUE_CONFIG.COLUMNS.READER_LINK_WITH_NEW_DOCS_ICON.name
    ].compact
  end
  # rubocop:enable Metrics/AbcSize
end
