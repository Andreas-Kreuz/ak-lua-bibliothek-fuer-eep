import Chip from '@mui/material/Chip';
import Stack from '@mui/material/Stack';

function AppSingleSelectionChips(props: {
  elements: { name: string; action?: React.EventHandler<any> }[];
  activeElement: string;
}) {
  return (
    <Stack direction="row" spacing={1} sx={{ mt: 1, backgroundColor: 'rgba(255,255,255,0.8)', borderRadius: '120px' }}>
      {props.elements.map((e) => (
        <Chip
          label={e.name}
          variant="filled"
          key={e.name}
          color={props.activeElement === e.name ? 'primary' : 'default'}
          clickable={(e.action && true) || false}
          onClick={e.action}
        ></Chip>
      ))}
    </Stack>
  );
}

export default AppSingleSelectionChips;
