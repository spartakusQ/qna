class AnswersController < ApplicationController

  before_action :find_question, only: %i[new create]
  before_action :find_answers, only: :edit

  def new
    @answer = @question.answers.new
  end

  def edit
  end


  def create
    @answer = @question.answers.new(answers_params)

    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:body, :question_id)
  end

  def find_answers
    @answer = Answer.find(params[:id])
  end

end
