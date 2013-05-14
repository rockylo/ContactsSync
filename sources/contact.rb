require 'json'
require 'rest_client'

class Contact < SourceAdapter
  def initialize(source,credential) 
    @base = 'http://localhost:8081/Contact/'
    super(source,credential)
  end
 
  def login
    # TODO: Login to your data source here if necessary
  end
 
  #def query(params=nil)
    # TODO: Query your backend data source and assign the records 
    # to a nested hash structure called @result. For example:
    # @result = { 
    #   "1"=>{"name"=>"Acme", "industry"=>"Electronics"},
    #   "2"=>{"name"=>"Best", "industry"=>"Software"}
    # }
    #raise SourceAdapterException.new("Please provide some code to read records from the backend data source")
  #end
  
  def query(params=nil)
    puts 'calling query'

    parsed = JSON.parse(RestClient.get("#{@base}query").body)

    @result={}
    parsed.each do |item|
      @result[["ID"].to_s] = item
    end if parsed
    return @result
  end
 
  def sync
    # Manipulate @result before it is saved, or save it 
    # yourself using the Rhoconnect::Store interface.
    # By default, super is called below which simply saves @result
    super
  end
 
  def create(create_hash)
    res = RestClient.post(@base,:contact => create_hash)
    
    JSON.parse(
      RestClient.get("#{res.headers[:location]}.json").body
    )["contact"]["id"]
    # TODO: Create a new record in your backend data source
    #raise "Please provide some code to create a single record in the backend data source using the create_hash"
  end

  def update(update_hash)
    
    obj_id = update_hash['id']
    update_hash.delete('id')   
    RestClient.put("#{@base}/#{obj_id}",:contact => update_hash)
    # TODO: Update an existing record in your backend data source
    #raise "Please provide some code to update a single record in the backend data source using the update_hash"
  end
 
  def delete(delete_hash)
    
    RestClient.delete("#{@base}/#{delete_hash['id']}")
    # TODO: write some code here if applicable
    # be sure to have a hash key and value for "object"
    # for now, we'll say that its OK to not have a delete operation
    # raise "Please provide some code to delete a single object in the backend application using the object_id"
  end
 
  def logoff
    # TODO: Logout from the data source if necessary
  end
end