import { LitElement, css, html, nothing } from "lit";
import { customElement, state } from "lit/decorators.js";

import { consume } from "@lit/context";
import { queryContext } from "../contexts";

import { global, wrapper } from "../styles";

const NAME = "canary-content";

@customElement(NAME)
export class CanaryContent extends LitElement {
  @consume({ context: queryContext, subscribe: true })
  @state()
  private _query = "";

  render() {
    return html`
      <div class="container">
        <slot name="mode"></slot>
        ${this._query ? html`<slot name="footer"></slot>` : nothing}
      </div>
    `;
  }

  static styles = [
    global,
    wrapper,
    css`
      .container {
        width: 100%;
        max-width: var(--canary-content-max-width, 600px);

        outline: none;
        padding-top: 6px;
        padding-bottom: 12px;

        border: none;
        border-radius: 8px;
        box-shadow:
          0 20px 25px -5px rgb(0 0 0 / 0.1),
          0 8px 10px -6px rgb(0 0 0 / 0.1);

        background-color: var(--canary-color-gray-100);
      }

      @media (min-width: 50rem) {
        .container {
          width: var(--canary-content-max-width, 600px);
        }
      }
    `,
  ];
}

declare global {
  interface HTMLElementTagNameMap {
    [NAME]: CanaryContent;
  }
}
