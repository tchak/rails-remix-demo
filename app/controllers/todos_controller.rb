class TodosController < ApplicationController
  def index
    @todo = Todo.new
    @todos = Todo.order(:created_at).all
  end

  def create
    todo = Todo.new(create_params)

    if todo.save
      flash[:created?] = true
    else
      flash.alert = todo.errors.full_messages
    end

    redirect_back(fallback_location: root_path)
  end

  def update
    todo = Todo.find(params[:id])

    if !todo.update(update_params)
      flash.now.alert = todo.errors.full_messages
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  def destroy
    todo = Todo.find(params[:id])
    todo.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(helpers.dom_id(todo, :item)) }
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  def about
  end

  private

  def create_params
    params.require(:todo).permit(:title)
  end

  def update_params
    params.require(:todo).permit(:title, :completed)
  end
end
