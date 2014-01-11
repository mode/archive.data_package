def inline_resource
  {
    "name" => "standard",
    "data" => [
      [1, 'Josh', 'Ferguson'],
      [2, 'Heather', 'Rivers'],
      [3, 'Paul', 'Thurlow']
    ],

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
        }
      ],

      'primaryKey' => ['id']
    }
  }
end

def standard_resource
  {
    "name" => "standard",
    "path" => "standard.csv",

    'dialect' => {
      'delimiter' => ","
    },

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

def http_resource
  {
    "name" => "standard",
    "url" => 'http://www.modeanlaytics.com/besquared/users',

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
        }
      ],

      'primaryKey' => ['id']
    }
  }
end

def remote_resource
  {
    "name" => "country-codes",
    "path" => "data/country-codes.csv",
    "url"  => "https://datahub.com/datasets/country-codes.csv",

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
        }
      ],

      'primaryKey' => ['id']
    }
  }
end