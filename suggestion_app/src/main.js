// src/main.js
import { createApp, provide, h } from 'vue';
import App from './App.vue';
import { DefaultApolloClient } from '@vue/apollo-composable';
import { apolloClient } from './apollo/apolloClient'; // 确保路径正确
import 'bootstrap/dist/css/bootstrap.min.css';

const app = createApp({
    setup() {
        provide(DefaultApolloClient, apolloClient);
    },
    render: () => h(App),
});

app.mount('#app');
