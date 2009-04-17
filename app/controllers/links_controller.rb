class LinksController < ApplicationController
  before_filter :load_question
  before_filter :current_user?, :only => :edit

  def load_question
    @question = Question.find(params[:question_id])
  end

  # GET /links/1
  # GET /links/1.xml
  def show
    @link = @question.links.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @link }
    end
  end
  
  def edit
    @link = @question.links.find(params[:id])
  end

  # POST /links
  # POST /links.xml
  def create
    @link = @question.links.new(params[:link])
    @link.user_id = current_user.id

    respond_to do |format|
      if @link.save
        flash[:notice] = 'link was successfully created.'
        format.html { redirect_to(@question) }
        format.xml  { render :xml => @link, :status => :created, :location => @link }
      else
        format.html { redirect_to @question }
        flash[:notice] = 'Link must start with "http://"'
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @link = @question.links.find(params[:id])

    respond_to do |format|
      if @link.update_attributes(params[:link])
        flash[:notice] = 'link was successfully updated.'
        format.html { redirect_to(@question) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @link = @question.links.find(params[:id])
    @link.destroy

    respond_to do |format|
      format.html { redirect_to(@question) }
      format.xml  { head :ok }
    end
  end
private

  def current_user?
    unless logged_in? && current_user.id == @question.links.find(params[:id]).user_id
      flash[:notice] = "Not your link"
      redirect_to questions_path
    end
  end
  
end
