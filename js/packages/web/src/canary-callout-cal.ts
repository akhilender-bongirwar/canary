import { LitElement, html } from "lit";
import { customElement, property } from "lit/decorators.js";

import { CalloutMixin } from "./mixins";
import { callout } from "./styles";

import "./canary-logo-cal";
import "./canary-hero-icon";

@customElement("canary-callout-cal")
export class CanaryCalloutCal extends CalloutMixin(LitElement) {
  @property() message = "Wanna schedule a call?";
  @property() url = "";

  @property({ type: Array }) keywords: string[] = [
    "meeting",
    "schedule",
    "cal.com",
    "calend",
  ];

  renderCallout() {
    return html`
      <button @click=${this._handleClick}>
        <span> 👋 ${this.message} </span>
        <div>
          <canary-logo-cal url=${this.url}></canary-logo-cal>
          <canary-hero-icon name="chevron-right"></canary-hero-icon>
        </div>
      </button>
    `;
  }

  private _handleClick() {
    window.open(this.url, "_blank");
  }

  static styles = callout;
}
