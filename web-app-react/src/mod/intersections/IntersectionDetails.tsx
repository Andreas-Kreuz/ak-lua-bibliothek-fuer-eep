import AppCardBg from '../../ui/AppCardBg';
import AppCardGrid from '../../ui/AppCardGrid';
import AppPageHeadline from '../../ui/AppPageHeadline';
import AppPage from '../../ui/AppPage';
import AppCardGridContainer from '../../ui/AppCardGridContainer';
import Stack from '@mui/material/Stack';
import Chip from '@mui/material/Chip';
import AppCaption from '../../ui/AppCaption';
import useIntersection from './useIntersection';
import useIntersectionSwitching from './useIntersectionSwitching';
import { useMatches } from 'react-router-dom';
import AppSingleSelectionChips from '../../ui/AppSingleSelectionChips';

function IntersectionDetails() {
  const matches = useMatches();
  const id = parseInt(matches[0].params.intersectionId || '555');
  const i = useIntersection(id);
  const switchings = useIntersectionSwitching(i?.name);

  return (
    <AppPage>
      {i && (
        <>
          <AppPageHeadline>Kreuzung {i.name}</AppPageHeadline>
          <AppCardGridContainer>
            <AppCardGrid key={1}>
              <AppCardBg title="Kreuzung" id={i.name} image="/assets/card-img-intersection.jpg">
                <Stack>
                  <AppCaption gutterTop>Schaltungen</AppCaption>
                  <AppSingleSelectionChips
                    elements={switchings.map((s) => {
                      return { name: s.name, action: undefined };
                    })}
                    activeElement={i.currentSwitching}
                  />
                </Stack>
              </AppCardBg>
            </AppCardGrid>
          </AppCardGridContainer>
        </>
      )}
    </AppPage>
  );
}

export default IntersectionDetails;
