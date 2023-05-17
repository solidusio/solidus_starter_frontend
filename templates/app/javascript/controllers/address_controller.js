import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['country', 'stateId', 'stateName', 'inputs']
  static values = { onlyOneCountryAllowed: Boolean }

  statesByCountry = {}
  statesFetching = {}

  get countryId() {
    return this.countryTarget.value
  }

  get disabledValue() {
    return this.inputsTarget.disabled
  }

  set disabledValue(value) {
    this.inputsTarget.disabled = value
  }

  initialize() {
    this.updateState()
  }

  async updateState() {
    const countryId = this.countryId

    if (!countryId) return

    if (!this.statesByCountry[countryId]) {
      // Don't fetch twice if we're already waiting for a country
      this.statesFetching[countryId] =
        this.statesFetching[countryId] ||
        fetch(`/api/states?country_id=${countryId}`)

      const data = await (await this.statesFetching[countryId]).json()

      this.statesByCountry[countryId] = data
    }

    this.render()
  }

  render() {
    const { states, states_required: required } =
      this.statesByCountry[this.countryId] || {}

    if (!states) {
      // noop
    } else if (states.length > 0) {
      this.renderStatesSelect(states, required)
    } else {
      this.renderStateName(required)
    }
  }

  renderStatesSelect(states, required) {
    const selected = parseInt(this.stateIdTarget.value)
    const statesWithBlank = [{ name: '', id: '' }].concat(states)

    this.stateIdTarget.innerHTML = ''

    statesWithBlank.forEach((state) => {
      const option = document.createElement('option')

      option.value = state.id
      option.innerText = state.name
      option.dataset.abbr = state.abbr

      if (selected === state.id) {
        option.selected = true
      }

      this.stateIdTarget.appendChild(option)
    })

    this.stateIdTarget.disabled = false
    this.stateIdTarget.style.display = 'block'
    this.stateIdTarget.required = required

    this.stateNameTarget.disabled = true
    this.stateNameTarget.style.display = 'none'
  }

  renderStateName(required) {
    this.stateIdTarget.disabled = true
    this.stateIdTarget.style.display = 'none'

    this.stateNameTarget.disabled = false
    this.stateNameTarget.style.display = 'block'
    this.stateNameTarget.required = required
  }
}
