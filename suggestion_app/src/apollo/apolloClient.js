import { ApolloClient, InMemoryCache, createHttpLink } from '@apollo/client/core';
import { provideApolloClient } from '@vue/apollo-composable';

const httpLink = createHttpLink({
    uri: 'http://localhost:8080/graphql',
});

const cache = new InMemoryCache();
const apolloClient = new ApolloClient({
    link: httpLink,
    cache,
});

provideApolloClient(apolloClient);

export { apolloClient };
