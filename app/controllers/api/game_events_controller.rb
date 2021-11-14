class Api::GameEventsController < ApplicationController
  def preview
    @html = view_context.markdown(params[:body])
  end
end