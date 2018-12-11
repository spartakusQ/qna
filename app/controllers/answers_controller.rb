class AnswersController < ApplicationController

  before_action :find_question, only: [:new, :create]
  before_action :find_answers, only: [:edit, :update]

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

  def update
    if @answer.update(answers_params)
      redirect_to question_path(@answer.question)
    else
      render :edit
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
