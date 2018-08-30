class SupplementalClaim < ClaimReview
  validates :receipt_date, presence: { message: "blank" }, if: :saving_review

  END_PRODUCT_RATING_CODE = "040SCR".freeze
  END_PRODUCT_NONRATING_CODE = "040SCNR".freeze
  END_PRODUCT_MODIFIERS = %w[040 041 042 043 044 045 046 047 048 049].freeze

  def ui_hash
    {
      veteranFormName: veteran.name.formatted(:form),
      veteranName: veteran.name.formatted(:readable_short),
      veteranFileNumber: veteran_file_number,
      claimId: end_product_claim_id,
      receiptDate: receipt_date,
      issues: request_issues
    }
  end

  def end_product_description
    end_product_establishment.description
  end

  def end_product_base_modifier
    # This is for EPs not yet created or that failed to create
    end_product_establishment.valid_modifiers.first
  end

  def end_product_claim_id
    end_product_establishment.reference_id
  end

  private

  def find_end_product_establishment(ep_code)
    EndProductEstablishment.find_by(source: self, code: ep_code)
  end

  def new_end_product_establishment(ep_code, invalid_modifiers)
    EndProductEstablishment.new(
      veteran_file_number: veteran_file_number,
      reference_id: end_product_reference_id,
      claim_date: receipt_date,
      payee_code: payee_code,
      code: ep_code,
      valid_modifiers: END_PRODUCT_MODIFIERS,
      invalid_modifiers: invalid_modifiers,
      claimant_participant_id: claimant_participant_id,
      source: self,
      station: "397" # AMC
    )
  end

  def end_product_establishment(rated: true, invalid_modifiers: [])
    ep_code = issue_code(rated)
    @end_product_establishments ||= {}
    @end_product_establishments[rated] ||=
      find_end_product_establishment(ep_code) || new_end_product_establishment(ep_code, invalid_modifiers)
  end

  def issue_code(rated)
    rated ? END_PRODUCT_RATING_CODE : END_PRODUCT_NONRATING_CODE
  end
end
