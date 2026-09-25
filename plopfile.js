export default function (plop) {

  plop.setHelper('copyrightYear', function () {
    return new Date().getFullYear();
  });

  plop.setHelper('underline', function (char, length) {
    return char.repeat(length);
  });

  plop.setHelper('titlecase', function (text) {
    return text.charAt(0).toUpperCase() + text.slice(1);
  });

  plop.setHelper('uppercase', function (text) {
    return text.toUpperCase();
  });

  plop.setHelper('prefixConst', function (text) {
    return text.toUpperCase().replace(/\s+/g, '').replace(/[^A-Z]/g, '_');
  });

  const prompts = [
    {
      type: 'input',
      name: 'project_id',
      message: 'Project ID'
    },
    {
      type: 'input',
      name: 'project_name',
      message: 'Project Name'
    },
    {
      type: 'input',
      name: 'project_desc',
      message: 'Project Description '
    },
    {
      type: 'input',
      name: 'author_name',
      message: 'Author Name'
    },
    {
      type: 'input',
      name: 'author_email',
      message: 'Author Email'
    },
    {
      type: 'input',
      name: 'author_url',
      message: 'Author URL'
    },
    {
      type: 'input',
      name: 'github_id',
      message: 'GitHub ID'
    },
    {
      type: 'input',
      name: 'github_repo',
      message: 'GitHub Repository'
    },
    {
      type: 'input',
      name: 'github_token_prefix',
      message: 'GitHub Actions token prefix'
    }
  ];

  plop.setGenerator('packer-python', {
    description: 'Packer-python Plop',
    prompts: prompts,
    actions: [
      {
        type: 'addMany',
        destination: 'stage',
        templateFiles: [
          'templates/packer-python/.*/*/*/*',
          'templates/packer-python/.*/*/*',
          'templates/packer-python/**/.*',
          'templates/packer-python/**/*'
        ]
      }
    ]
  });

  plop.setGenerator('packer-python-partials', {
    description: 'Packer-python partials template',
    prompts: prompts,
    actions: [
      {
        type: 'addMany',
        destination: 'stage/packer-python-partials',
        templateFiles: [
          'templates/packer-python-partials/*'
        ],
        base: 'templates/packer-python-partials'
      }
    ]
  });

  plop.setGenerator('packer-node', {
    description: 'Packer-node Plop',
    prompts: prompts,
    actions: [
      {
        type: 'addMany',
        destination: 'stage',
        templateFiles: [
          'templates/packer-node/.*/*/*/*',
          'templates/packer-node/.*/*/*',
          'templates/packer-node/**/.*',
          'templates/packer-node/**/*'
        ]
      }
    ]
  });

  plop.setGenerator('packer-node-partials', {
    description: 'Packer-node partials template',
    prompts: prompts,
    actions: [
      {
        type: 'addMany',
        destination: 'stage/packer-node-partials',
        templateFiles: [
          'templates/packer-node-partials/*'
        ],
        base: 'templates/packer-node-partials'
      }
    ]
  });
};