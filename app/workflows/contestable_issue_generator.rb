# frozen_string_literal: true

class ContestableIssueGenerator
  def initialize(review)
    @review = review
  end

  delegate :finalized_decision_issues_before_receipt_date, to: :review
  delegate :receipt_date, to: :review

  def contestable_issues
    return contestable_decision_issues unless review.can_contest_rating_issues?

    contestable_rating_issues + contestable_decision_issues + contestable_rating_decisions
  end

  private

  attr_reader :review

  def contestable_rating_issues
    from_ratings.reject { |contestable_issue| decision_issue_duplicate_exists?(contestable_issue) }
  end

  def contestable_decision_issues
    from_decision_issues.reject { |contestable_issue| contestable_issue.decision_issue&.voided? }
  end

  def contestable_rating_decisions
    return [] unless FeatureToggle.enabled?(:contestable_rating_decisions, user: RequestStore[:current_user])

    from_rating_decisions.reject { |contestable_issue| decision_issue_duplicate_exists?(contestable_issue) }
  end

  def from_ratings
    return [] unless receipt_date

    rating_issues
      .select { |issue| issue.profile_date && issue.profile_date.to_date < receipt_date }
      .map { |rating_issue| ContestableIssue.from_rating_issue(rating_issue, review) }
  end

  def from_decision_issues
    @from_decision_issues ||= finalized_decision_issues_before_receipt_date.map do |decision_issue|
      ContestableIssue.from_decision_issue(decision_issue, review)
    end
  end

  def from_rating_decisions
    return [] unless receipt_date

    # rating decisions are a superset of every disability ever recorded for a veteran,
    # so filter out any that are duplicates of a rating issue or that are not related to their parent rating.
    rating_decisions
      .select(&:contestable?)
      .reject(&:rating_issue?)
      .select { |rating_decision| rating_decision.profile_date && rating_decision.profile_date.to_date < receipt_date }
      .map { |rating_decision| ContestableIssue.from_rating_decision(rating_decision, review) }
  end

  def rating_issues
    rating_hash_deserialize(from: :issues, to: RatingIssue)
  end

  def rating_decisions
    rating_hash_deserialize(from: :decisions, to: RatingDecision)
  end

  def rating_hash_deserialize(from:, to:)
    ratings.inject([]) do |result, rating_hash|
      result + rating_hash[from].map { |hash| to.deserialize(hash) }
    end
  end

  def decision_issue_duplicate_exists?(contestable_issue)
    from_decision_issues.any? do |potential_duplicate|
      contestable_issue.rating_issue_reference_id == potential_duplicate.rating_issue_reference_id
    end
  end

  def ratings
    review.cached_serialized_ratings
  end
end
