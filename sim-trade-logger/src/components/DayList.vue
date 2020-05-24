<template>
  <div class="hello">
    <pre>{{ days }}</pre>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
// import raw from "./raw.txt";
// eslint-disable-next-line import/no-webpack-loader-syntax
import raw from "raw-loader!./raw.txt";

@Component
export default class DayList extends Vue {
  // @Prop() private msg!: string;

  private raw: string = raw;

  get days() {
    console.log(this);
    return raw;
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
