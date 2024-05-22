<template>
  <div>
    <div class="form-group">
      <input 
        v-model="query" 
        @input="fetchSuggestions" 
        class="form-control col-md-6" 
        placeholder="Type to search..." 
        aria-haspopup="true" 
        aria-expanded="suggestions.length > 0" 
        aria-controls="suggestions-dropdown"
        style="max-width:300px;" 
      />
      <ul 
        id="suggestions-dropdown" 
        v-if="suggestions.length" 
        class="dropdown-menu show" 
        style="width: 100%; max-width: 300px;" 
      >
        <li 
          v-for="suggestion in suggestions" 
          :key="suggestion" 
          class="dropdown-item" 
          @click="selectSuggestion(suggestion)"
        >
          {{ suggestion }}
        </li>
      </ul>
    </div>
    <div id="map" style="width: 100%; height: 400px;"></div>
  </div>
</template>

<script>
import { ref, watch, onMounted, watchEffect } from 'vue';
import { useQuery } from '@vue/apollo-composable';
import gql from 'graphql-tag';
import axios from 'axios';

export default {
  name: 'StateTypeahead',
  setup() {
    const query = ref('');
    const suggestions = ref([]);
    const selectedState = ref('');
    const map = ref(null);
    const marker = ref(null);

    const FETCH_STATES = gql`
      query FetchStates($query: String!) {
        states(query: $query) {
          name
        }
      }
    `;

    const { result, loading, error, refetch } = useQuery(FETCH_STATES, () => ({ query: query.value }), { fetchPolicy: 'no-cache' });

    const fetchSuggestions = () => {
      if (!query.value) {
        suggestions.value = [];
        return;
      }
      if (!loading.value && !error.value && result.value) {
        suggestions.value = result.value.states.map(state => state.name);
      }
    };

    watch(query, async (newQuery) => {
      if (newQuery) {
        await refetch(); // 重新执行查询
      } else {
        suggestions.value = [];
      }
    });

    watchEffect(() => {
      if (!loading.value) {
        fetchSuggestions(); // 更新建议
      }
    });

    const selectSuggestion = async (suggestion) => {
      selectedState.value = suggestion;
      try {
        const response = await axios.get(`https://maps.googleapis.com/maps/api/geocode/json?address=${suggestion}&key=AIzaSyBGwpPV5hA426DStnuSRuETyYuj6x2Ix-s`);
        if (response.data.status === 'OK' && response.data.results.length > 0) {
          const location = response.data.results[0].geometry.location;
          map.value.setCenter(location);
          if (marker.value) {
            marker.value.setMap(null); 
          }
          marker.value = new window.google.maps.Marker({
            position: location,
            map: map.value,
          });
        } else {
          console.error('Error fetching location: ', response.data.status);
        }
      } catch (error) {
        console.error('Error fetching location:', error);
      }
    };

    const loadGoogleMaps = (callback) => {
      const existingScript = document.getElementById('googleMaps');

      if (!existingScript) {
        const script = document.createElement('script');
        script.src = `https://maps.googleapis.com/maps/api/js?key=AIzaSyBGwpPV5hA426DStnuSRuETyYuj6x2Ix-s`;
        script.id = 'googleMaps';
        document.body.appendChild(script);

        script.onload = () => {
          console.log('Google Maps script loaded successfully.');
          if (callback) callback();
        };

        script.onerror = () => {
          console.error('Error loading Google Maps script.');
        };
      } else {
        if (callback) callback();
      }
    };

    onMounted(() => {
      const mapContainer = document.getElementById('map');
      if (mapContainer) {
        console.log('Map container found:', mapContainer);
        loadGoogleMaps(() => {
          map.value = new window.google.maps.Map(mapContainer, {
            center: { lat: 37.0902, lng: -95.7129 },
            zoom: 4,
          });
          console.log('Map initialized.');
        });
      } else {
        console.error('Map container not found.');
      }
    });

    return {
      query,
      suggestions,
      fetchSuggestions,
      selectSuggestion,
      selectedState,
      map,
      loading,
      error,
    };
  }
};
</script>

<style>
#map {
  width: 100%;
  height: 400px;
}
</style>
