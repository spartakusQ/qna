class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:update, :destroy, :best]

  def create
    @answer = @question.answers.new(answers_params)
    @answer.user = current_user
    flash[:notice] = 'Your answers successfully created.' if @answer.save
  end

  def update
    if current_user.author?(@answer)
      @answer.update(answers_params)
      @question = @answer.question
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer successfully deleted.'
    else
      flash[:notice] = 'You not a author.'
      redirect_to @answer.question
    end
  end

  def best
    @answer.best! if current_user.author?(@answer.question)
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
