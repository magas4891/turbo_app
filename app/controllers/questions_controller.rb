class QuestionsController < ApplicationController
  before_action :set_question, only: %i[ show edit update destroy ]

  # GET /questions or /questions.json
  def index
    @questions = Question.all
  end

  # GET /questions/1 or /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('new_question', partial: 'form', locals: { question: @question })
        ]
      end
    end
  end

  # GET /questions/1/edit
  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(@question, partial: 'form', locals: { question: @question })
      end
    end
  end

  # POST /questions or /questions.json
  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.turbo_stream do
          flash.now[:success] = "Question was successfully created."
          render turbo_stream: [
            turbo_stream.append('questions', partial: 'question', locals: { question: @question }),
            turbo_stream.update('flash', partial: 'shared/flash'),
            turbo_stream.update('new_question', html: '')
          ]
        end
        format.html { redirect_to question_url(@question), notice: "Question was successfully created." }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1 or /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(@question, partial: 'question', locals: { question: @question })
        end
        format.html { redirect_to question_url(@question), notice: "Question was successfully updated." }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1 or /questions/1.json
  def destroy
    @question.destroy

    respond_to do |format|
      format.turbo_stream do
        flash.now[:success] = "Question was successfully deleted."
        render turbo_stream: [
          turbo_stream.remove(@question),
          turbo_stream.update('flash', partial: 'shared/flash'),
        ]
      end
      format.html { redirect_to questions_url, notice: "Question was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:title, :body)
    end
end
