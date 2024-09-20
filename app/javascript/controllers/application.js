import { Application } from "@hotwired/stimulus"

// Configure Stimulus development experience
const application = Application.start()
application.debug = false
window.Stimulus = application

// Import Turbo and Stimulus controllers
import "@hotwired/turbo-rails"
import "controllers"

// Bootstrap should not be imported here if it's included via CDN
