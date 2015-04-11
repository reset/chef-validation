def node
  {
    'cookbook' => {
      'fun' => {
        'stuff' => 'value',
        'stuff2' => [
          'secret',
          'production',
        ],
      },
      'timeout' => 200,
      'memory' => {
        'min' => 1024,
        'max' => 2048
      },
      'tags' => [
        'production',
        'secret'
      ],
      'works' => false,
      'simba' => :foo,
      'party' => {
        'yes' => {
          'party' => true,
          'work'  => false,
          'things' => {
            'wooo' => {
              'stuff' => true
            }
          }
        },
        'no' => {
          'party' => false,
          'work'  => true
        }
      },
      'volumes' => [
        {
          'user' => 'ubuntu',
          'device' => '/dev/sdm',
          'mount' => '/data'
        },
        {
          'mode' => '777',
          'device' => '/dev/sdo',
          'mount' => '/db'
        }
      ]
    }
  }
end

def recipes
  [
    'config',
    'foo',
  ]
end
