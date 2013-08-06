class UsersController < ApplicationController
  consumes :users#, :posts

  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

	def create
    @user = User.new(params[:users])
    #@user.build_errors JSON.parse '{"name": ["required"], "email": ["invalid", "required"], "cpf": ["invalid", "required"], "city_id": ["invalid"], "phone": ["invalid_format"]}'
    respond_to do |format|
      #if @user.save
      #else
        format.html { render action: "new" }
        format.json { render json: @user.errors}
      #end
    end
	end

  def edit
    @user = User.new(id: 1, name: 'Teste', email: 'teste@teste.com', birth_date: '12/04/2013' )
  end

  def check_mail
    email = params[:email]
    if email == "lccezinha@gmail.com" 
      render json: JSON.parse('{"status":"success","entity_memberships":["Clube de Autores", "Prestigio"]}'), status: 200
    elsif email.present?
      render json: JSON.parse('{"status":"fail","error":"user not found"}'), status: 404
    else
      render json: JSON.parse('{"status":"fail","error":"email cant be blank"}'), status: 400
    end
  end
end