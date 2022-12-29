import * as commandLineArgs from 'command-line-args';
import * as commandLineUsage from 'command-line-usage';

export default class CommandLineParser {
  parseOptions(): commandLineArgs.CommandLineOptions {
    const optionDefinitions = [
      {
        name: 'exchange-dir',
        alias: 'd',
        typeLabel: '{underline <dir>}',
        description: 'The directory to process.',
      },
      {
        name: 'testmode',
        alias: 't',
        type: Boolean,
        description: 'If true, this app will go to TESTMODE.',
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
