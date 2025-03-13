require 'google/cloud/translate/v3'
class Integrations::GoogleTranslate::TranslateService
  pattr_initialize [:content!, :target_language!]

  def perform
    return if content.blank?
    return if hook.blank?

    response = client.translate_text(
      contents: [content],
      target_language_code: target_language,
      parent: "projects/#{hook.settings['project_id']}"
    )

    return if response.translations.first.blank?

    response.translations.first.translated_text
  end

  private

  def hook
    @hook ||= Current.account.hooks.find_by(app_id: 'google_translate')
  end

  def client
    @client ||= ::Google::Cloud::Translate::V3::TranslationService::Client.new do |config|
      config.credentials = hook.settings['credentials']
    end
  end
end
