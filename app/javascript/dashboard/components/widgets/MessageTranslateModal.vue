<script>
import { useVuelidate } from '@vuelidate/core';
import { useMessageFormatter } from 'shared/composables/useMessageFormatter';
import { required } from '@vuelidate/validators';
import ContentApi from '../../api/inbox/content';
import importedlanguages from 'dashboard/components/widgets/conversation/advancedFilterItems/languages';

export default {
  props: {
    message: {
      type: String,
      default: "",
    },
    language: {
      type: String,
      default: "en",
    },
  },
  emits: ['close', 'applyText', 'updateLanguage'],
  setup() {
    const { formatMessage } = useMessageFormatter();
    const v$ = useVuelidate();

    return { formatMessage, v$ };
  },
  data() {
    return {
      translatedContent: '',
      isTranslating: true,
      targetedLanguage: this.language,
      languages: importedlanguages,
    };
  },
  validations: {
    targetedLanguage: {
      required,
    },
  },
  computed: {
    headerTitle() {
      return this.message === "" ? "No Content added" : "Translate Languages"
    },
  },
  mounted() {
    this.translateToLanguage();
  },
  methods: {
    onClose() {
      this.$emit('close');
    },
    async translateToLanguage() {
      this.isTranslating = true;

      const response = await ContentApi.translate(this.message, this.targetedLanguage);
      this.translatedContent = response.data.content || "";

      this.isTranslating = false;
    },
    onLanguageChange() {
      this.translateToLanguage();
      this.$emit('updateLanguage', this.targetedLanguage);
    },
    applyText() {
      this.$emit('applyText', this.translatedContent);
      this.onClose();
    },
  },
};
</script>

<template>
  <div class="flex flex-col">
    <woot-modal-header :header-title="headerTitle" />
    <form
      class="flex flex-col w-full modal-content"
      @submit.prevent="applyText"
    >
      <div v-if="message" class="w-full">
        <h4 class="mt-1 text-base text-slate-700 dark:text-slate-100">
          {{ $t('INTEGRATION_SETTINGS.OPEN_AI.ASSISTANCE_MODAL.DRAFT_TITLE') }}
        </h4>
        <p v-dompurify-html="formatMessage(message, false)" />
        <div class="mt-3">
          <label :class="{ error: v$.targetedLanguage.$error }">
            Targeted Language
            <select
              v-model="targetedLanguage"
              @change="onLanguageChange"
            >
              <option
                v-for="lang in languages"
                :key="lang.id"
                :value="lang.id"
                
              >
                {{ `${lang.name} (${lang.id})` }}
              </option>
            </select>
            <span v-if="v$.targetedLanguage.$error" class="message">
              {{ $t('GENERAL_SETTINGS.FORM.LANGUAGE.ERROR') }}
            </span>
          </label>
        </div>
        <h4 class="mt-1 text-base text-slate-700 dark:text-slate-100">
          Translated content
        </h4>
      </div>
      <div>
        <div v-if="isTranslating" class="flex justify-start">
          <div class="flex items-center space-x-2">
            <span class="text-n-iris-11 font-medium">
              Translating
            </span>
            <div class="flex space-x-1">
              <div
                class="w-2 h-2 rounded-full bg-n-iris-9 animate-bounce [animation-delay:-0.3s]"
              />
              <div
                class="w-2 h-2 rounded-full bg-n-iris-9 animate-bounce [animation-delay:-0.15s]"
              />
              <div class="w-2 h-2 rounded-full bg-n-iris-9 animate-bounce" />
            </div>
          </div>
        </div>
        <p v-else v-dompurify-html="formatMessage(translatedContent, false)" />
      </div>

      <div class="flex flex-row justify-end w-full gap-2 px-0 py-2">
        <woot-button variant="clear" @click.prevent="onClose">
          {{
            $t('INTEGRATION_SETTINGS.OPEN_AI.ASSISTANCE_MODAL.BUTTONS.CANCEL')
          }}
        </woot-button>
        <woot-button :disabled="!translatedContent">
          {{
            $t('INTEGRATION_SETTINGS.OPEN_AI.ASSISTANCE_MODAL.BUTTONS.APPLY')
          }}
        </woot-button>
      </div>
    </form>
  </div>
</template>

<style lang="scss" scoped>
.modal-content {
  @apply pt-2 px-8 pb-8;
}

.container {
  width: 100%;
}
</style>
