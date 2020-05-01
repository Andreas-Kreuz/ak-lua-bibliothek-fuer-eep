export default class CommandLineParser {
  parseOptions(): any {
    const commandLineArgs = require('command-line-args');
    const commandLineUsage = require('command-line-usage');

    const optionDefinitions = [
      {
        name: 'exchange-dir',
        alias: 'd',
        typeLabel: '{underline <dir>}',
        description: 'The directory to process.',
      },
      {
        name: 'help',
        alias: 'h',
        type: Boolean,
        description: 'Print this usage guide.',
      },
    ];
    const readOptions = commandLineArgs(optionDefinitions);

    if (readOptions.help) {
      const sections = [
        {
          header: 'Lua Communication Server for EEP',
          content: 'Server for Communication with the {italic Lua Library for EEP}.',
        },
        {
          header: 'Options',
          optionList: optionDefinitions,
        },
      ];
      const usage = commandLineUsage(sections);
      console.log(usage);
      process.exit(0);
    }

    // console.log(readOptions);
    return readOptions;
  }
}
