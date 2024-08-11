# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  include ApplicationHelper
  include PatientsHelper

  helper :application
  helper :patients

  default from: "Laboratorio MasterLab <masterlab@labtecsa.com>"
  layout "mailer"
end
