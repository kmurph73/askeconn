class Admin::AnswersController < ApplicationController
  before_filter :load_question, :authorized?
  layout 'admin'

  def load_question
    @question = Question.find(params[:question_id])
  end

  # GET /answers
  # GET /answers.xml
  def index
    @answers = @question.answers.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @answers }
    end
  end

  # GET /answers/1
  # GET /answers/1.xml
  def show
    @answer = @question.answers.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @answer }
    end
  end

  # GET /answers/new
  # GET /answers/new.xml
  def new
    @answer = @question.answers.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @answer }
    end
  end

  # GET /answers/1/edit
  def edit
    @answer = @question.answers.find(params[:id])
  end

  # POST /answers
  # POST /answers.xml
  def create
    @answer = @question.answers.new(params[:answer])
    @answer.user_id = current_user.id

    respond_to do |format|
      if @answer.save
        flash[:notice] = 'Answer was successfully created.'
        format.html { redirect_to([:admin, @question, @answer]) }
        format.xml  { render :xml => @answer, :status => :created, :location => @answer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @answer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /answers/1
  # PUT /answers/1.xml
  def update
    @answer = @question.answers.find(params[:id])

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        flash[:notice] = 'Answer was successfully updated.'
        format.html { redirect_to([:admin, @question, @answer]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @answer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.xml
  def destroy
    @answer = @question.answers.find(params[:id])
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to(admin_question_answers_url) }
      format.xml  { head :ok }
    end
  end
  
protected

  def authorized?
    unless logged_in? && current_user.login == "bah"
      flash[:notice] = "That place is for admins"
      redirect_to questions_path
    end
  end
  
end
