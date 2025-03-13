class Api::V1::Accounts::Contents::GoogleController < Api::V1::Accounts::BaseController
  def translate
    return head :ok if permitted_params[:content].blank?

    translated_content = Integrations::GoogleTranslate::TranslateService.new(
      content: permitted_params[:content],
      target_language: permitted_params[:target_language]
    ).perform

    render json: { content: translated_content }
  end

  private

  def permitted_params
    params.permit(:content, :target_language)
  end
end
