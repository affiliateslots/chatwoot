<script>
import { computed } from 'vue';
import MessageTranslateModal from './MessageTranslateModal.vue';
import NextButton from 'dashboard/components-next/button/Button.vue';
import { useStore, useStoreGetters } from 'dashboard/composables/store';

export default {
  components: {
    NextButton,
    MessageTranslateModal,
  },
  props: {
    message: {
      type: String,
      default: "",
    },
    conversationId: {
      type: [Number, String],
      required: true,
    }
  },
  emits: ['replaceText'],
  setup() {
    const getters = useStoreGetters();
    const store = useStore();

    const currentChat = computed(() => getters.getSelectedChat.value);
    const customAttributes = computed(() => currentChat.value.custom_attributes || {});
    const language = computed(() => customAttributes.value.language || 'en');

    return { currentChat, customAttributes, language, store };
  },
  data: () => ({
    showMessageTranslateModal: false,
  }),
  methods: {
    hideMessageTranslateModal() {
      this.showMessageTranslateModal = false;
    },
    openMessageTranslateModal() {
      this.showMessageTranslateModal = true;
    },
    insertText(message) {
      this.$emit('replaceText', message);
    },
    async updateLanguage (value) {
      const key = 'language';
      const updatedAttributes = { ...this.customAttributes, [key]: value };
      await this.store.dispatch('updateCustomAttributes', {
        conversationId: this.conversationId,
        customAttributes: updatedAttributes,
      });
    }
  },
};
</script>

<template>
  <div>
    <div class="relative">
      <NextButton
        @click="openMessageTranslateModal"
        tooltip.top-end="Translate Languages"
        icon="i-lucide-languages"
        slate
        faded
        sm
      />
      <woot-modal
        v-model:show="showMessageTranslateModal"
        :on-close="hideMessageTranslateModal"
      >
        <MessageTranslateModal
          :message="message"
          :language="language"
          @apply-text="insertText"
          @close="hideMessageTranslateModal"
          @update-language="updateLanguage"
        />
      </woot-modal>
    </div>
  </div>
</template>
