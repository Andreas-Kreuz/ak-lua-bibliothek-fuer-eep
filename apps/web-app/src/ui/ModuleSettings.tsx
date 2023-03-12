import ModuleSetting from './ModuleSetting';
import { LuaSettings } from '@ak/web-shared';
import Box from '@mui/material/Box';
import FormControl from '@mui/material/FormControl';
import FormLabel from '@mui/material/FormLabel';
import Typography from '@mui/material/Typography';

const ModuleSettings = (props: { settings: LuaSettings }) => {
  const categories = props.settings.settings
    .map((s) => s.category)
    .filter((value, index, array) => array.indexOf(value) === index);

  const catSettings = categories.map((c) => {
    return {
      category: c,
      settings: props.settings.settings
        .filter((s) => s.category === c)
        .sort((s1, s2) => {
          const a = s1.name;
          const b = s2.name;
          if (a < b) {
            return -1;
          }
          if (a > b) {
            return 1;
          }
          return 0;
        }),
    };
  });

  return (
    <>
      <FormControl component="fieldset" variant="standard">
        <FormLabel component="legend">{props.settings.moduleName}</FormLabel>
        {catSettings.map((c) => (
          <Box key={c.category}>
            <Typography variant="h6" pt={5}>
              {c.category}
            </Typography>
            {c.settings.map((s) => (
              <ModuleSetting setting={s} key={s.description} />
            ))}
          </Box>
        ))}
      </FormControl>
    </>
  );
};

export default ModuleSettings;
