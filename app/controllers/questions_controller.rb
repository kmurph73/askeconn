class QuestionsController < ApplicationController
  before_filter :authorized?, :only => :new
  
  # GET /questions
  # GET /questions.xml
  def index
    @questions = Question.search(params[:search], params[:page])
    @title = "All Questions"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @questions }
    end
  end
  
  def edit
    @question = Question.find(params[:id])
  end
  
  def update
    @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        flash[:notice] = 'Question was successfully updated.'
        format.html { redirect_to(@question) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /questions/1
  # GET /questions/1.xml
  def show
    @question = Question.find(params[:id])
    @answers = @question.answers.paginate(:page => params[:page], :per_page => 9)
    @title = @question.title

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @question }
    end
  end

  def new
    @question = Question.new
    @title = "Ask a Question"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @question }
    end
  end
  
  def showQuestions

  end
  
  # POST /questions
  # POST /questions.xml
  def create
    @question = Question.new(params[:question])
    @question.user_id = current_user.id

    respond_to do |format|
      if @question.save
        flash[:notice] = 'Question was successfully created.'
        @question.move_to_top
        format.html { redirect_to(@question) }
        format.xml  { render :xml => @question, :status => :created, :location => @question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

protected

  def authorized?
    unless logged_in?
      session[:original_uri] = request.request_uri
      flash[:notice] = "Log in to ask a question"
      redirect_to login_path
    end
  end
  
end
