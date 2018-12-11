class AnswersController < ApplicationController

  def new
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new
  end


  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(params.require(:answer).permit(:body, :question_id))
    
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end
end
