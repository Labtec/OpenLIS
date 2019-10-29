# frozen_string_literal: true

class WellKnownController < ApplicationController
  def change_password
    redirect_to profile_url, status: :temporary_redirect
  end
end
