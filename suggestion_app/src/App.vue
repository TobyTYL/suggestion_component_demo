<template>
  <div id="app">
    <StateTypeahead />
  </div>
</template>

<script>
import StateTypeahead from './components/StateTypehead.vue';

export default {
  name: 'App',
  components: {
    StateTypeahead
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
