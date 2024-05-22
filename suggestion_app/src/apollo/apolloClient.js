// src/apolloClient.js
import { ApolloClient, InMemoryCache, HttpLink } from '@apollo/client/core';
import { provideApolloClient } from '@vue/apollo-composable';

const httpLink = new HttpLink({
    uri: 'http://localhost:8080/graphql', // GraphQL 服务器的 URI
});

const cache = new InMemoryCache();

const apolloClient = new ApolloClient({
    link: httpLink,
    cache,
});

provideApolloClient(apolloClient);

export default apolloClient;
