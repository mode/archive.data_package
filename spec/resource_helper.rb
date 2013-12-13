def inline_resource
  # ...
end

def standard_resource
  {
    "name" => "standard",
    "path" => "standard.csv",

    'schema' => {
      'fields' => [
        {
          'name' => 'id',
          'type' => 'integer'
        },
        {
          'name' => 'first_name',
          'type' => 'string'
        },
        {
          'name' => 'last_name',
          'type' => 'string'
        },
        {
          'name' => 'email',
          'type' => 'string'
        },
        {
          'name' => 'country',
          'type' => 'string'
        },
        {
          'name' => 'ip_address',
          'type' => 'string'
        },
        {
          'name' => 'amount',
          'type' => 'number'
        },
        {
          'name' => 'active',
          'type' => 'boolean'
        },
        {
          'name' => 'activated_at',
          'type' => 'datetime'
        },
        {
          'name' => 'address',
          'type' => 'string'
        }
      ],

      'primaryKey' => ['id']
    }
  }
end