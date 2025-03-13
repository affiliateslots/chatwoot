/* eslint no-console: 0 */
/* global axios */
import ApiClient from '../ApiClient';

class ContentApi extends ApiClient {
  constructor() {
    super('contents', { accountScoped: true });
  }

  translate(content, targetLanguage) {
    return axios.post(
      `${this.url}/google/translate`,
      {
        content: content,
        target_language: targetLanguage,
      }
    );
  }
}

export default new ContentApi();
