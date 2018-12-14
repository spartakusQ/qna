class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:edit, :update, :destroy]

  def new
  end

  def edit
  end


  def create
    @answer = @question.answers.new(answers_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answers successfully created.'
    else
      render 'questions/show'
    end
  end

  def update
    if @answer.update(answers_params)
      redirect_to question_path(@answer.question)
    else
      render :edit
    end
  end

  def destroy
  if current_user.author?(@answer)
    @answer.destroy
    flash.notice = 'Answer successfully deleted.'
    redirect_to_answer
  else
    flash.notice = 'Only author can delete answer.'
    redirect_to_answer
  end
end


  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:body)
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def redirect_to_answer
    redirect_to @answer.question
  end

end
