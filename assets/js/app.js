// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.css";

import { Socket } from "phoenix";
import socket from "./socket";
import { LiveSocket } from "phoenix_live_view";
import Alpine from "alpinejs";
import "phoenix_html";

window.Alpine = Alpine;

// Hooks
let Hooks = {};
Hooks.Card = {
  currentCard: null,
  animatedClasses: function () {
    const animated = "animate__animated";
    const fadeOutRight = "animate__fadeOutRight";
    const fadeOutLeft = "animate__fadeOutLeft";
    const fadeInLeft = "animate__fadeInLeft";
    const fadeInRight = "animate__fadeInRight";

    return {
      all: [animated, fadeOutLeft, fadeOutRight, fadeInLeft, fadeInRight],
      next: {
        enter: [animated, fadeInRight],
        exit: [animated, fadeOutLeft],
      },
      prev: {
        enter: [animated, fadeInLeft],
        exit: [animated, fadeOutRight],
      },
    };
  },
  animateCard: function (dir, addExitAnimation = true) {
    let exitClasses = this.animatedClasses()[dir].exit;
    let enterClasses = this.animatedClasses()[dir].enter;
    let allClasses = this.animatedClasses().all;

    this.currentCard.classList.remove(...allClasses);
    this.currentCard.classList.add(...exitClasses);

    this.currentCard.addEventListener("animationend", () => {
      this.currentCard.classList.remove(...allClasses);
      this.currentCard.classList.add(...enterClasses);
    });
  },
  mounted() {
    this.currentCard = document.getElementById("current_card");
    this.currentCard.classList.add(...this.animatedClasses().next.enter);
  },
  updated() {
    this.handleEvent("next-card", () => {
      this.animateCard("next");
    });
    this.handleEvent("prev-card", () => {
      this.animateCard("prev");
    });
  },
};

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  dom: {
    onNodeAdded(node) {
      if (node._x_dataStack) {
        window.Alpine.initTree(node);
      }
    },
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        window.Alpine.clone(from, to);
        window.Alpine.initTree(to);
      }
    },
  },
  hooks: Hooks,
});

// Connect if there are any LiveViews on the page
liveSocket.connect();

// Expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
// The latency simulator is enabled for the duration of the browser session.
// Call disableLatencySim() to disable:
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
Alpine.start();
