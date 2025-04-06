import { lazy } from 'react';
import Grid from '@mui/material/Grid';
const AppCardBg = lazy(() => import('../../ui/AppCardBg'));
import TimeDesc from './model/TimeDesc';
import useStatisticsData from './useStatisticsData';
import React, { useState } from 'react';

const StatisticsOverview = (props: { title: string; times: TimeDesc[]; maxEntries?: number }) => {
  const [maxEntries, setMaxEntries] = useState(props.maxEntries || 10);
  const { max, list, ids } = useStatisticsData(props.times, maxEntries);
  const [expanded, setExpanded] = useState(false);
  const title = props.title;
  var items = Array(maxEntries)
    .fill(30)
    .map((x, i) => i);

  function colorOf(index: number) {
    switch (index) {
      case 0:
        return '#db2b1d';
      case 1:
        return '#dbdc1d';
      case 2:
        return '#17ac21';
      case 3:
        return '#412396';
      case 4:
        return '#a9b3ce';
      case 5:
        return '#cf4d6f';
      case 6:
        return '#7cdedc';
      case 7:
        return '#7284a8';
      case 8:
        return '#7284a8';
      case 9:
        return '#474954';
      case 10:
        return '#eb9486';
      default:
        return 'red';
    }
  }

  function scale(list: TimeDesc[][]) {
    const max1 = getMax(list);
    return Math.round(max1);
  }

  function getMax(list: TimeDesc[][]) {
    let max1 = 0;
    for (const entries of list) {
      max1 = Math.max(max1, maxOfSingleList(entries));
    }
    return max1;
  }

  function maxOfSingleList(entries: TimeDesc[]) {
    if (entries && entries.length > 0) {
      return entries.map((a) => a.ms).reduce((a, b) => a + b);
    } else {
      return 0;
    }
  }

  function scaledValueOf(i: number) {
    if (max === 0) {
      return 0;
    }
    // maximum shall be 80 % of the scale
    return (i / max) * 80;
  }

  function startXOf(index: number, list: TimeDesc[]) {
    return index === 0 || !list
      ? 0
      : list
          .slice(0, index)
          .map((a) => a.ms)
          .reduce((a, b) => a + b);
  }

  const base = 16;
  const fontSize = base * 0.75;
  const graphBarHeight = base * 1.125;
  const graphLineHeight = graphBarHeight * 1.33;
  const graphSvgHeight = Math.max(maxEntries, 1) * graphLineHeight - (graphLineHeight - graphBarHeight);

  const legendEntryHeight = base;
  const legendLineHeight = legendEntryHeight * 1.2;
  const legendSvgHeight = Math.max(ids.length, 1) * legendLineHeight - (legendLineHeight - legendEntryHeight);

  return (
    <Grid size={{ xs: 12 }}>
      <AppCardBg
        title={title + (maxEntries > 1 ? ' (max: ' : ' (') + scale(list) + ' ms)'}
        image={'/assets/title-image-simulator.jpg'}
      >
        <Grid paddingLeft={2} paddingRight={2}>
          <svg width="100%" height={graphSvgHeight} style={{ backgroundColor: 'white' }}>
            {items.map((item, index) => (
              <rect
                key={index}
                x="0"
                y={index * graphLineHeight}
                width={'100%'}
                height={graphBarHeight}
                style={{ fill: '#f9f9f9' }}
              />
            ))}
            {list.map((entries, j) => (
              <React.Fragment key={'Outer' + j}>
                {entries.map((item, i) => (
                  <React.Fragment key={'Inner' + i}>
                    <rect
                      x={scaledValueOf(startXOf(i, entries)) + '%'}
                      y={j * graphLineHeight}
                      width={scaledValueOf(item.ms) + '%'}
                      height={graphBarHeight}
                      style={{ fill: colorOf(i) }}
                    >
                      <title>
                        {item.ms.toFixed()} ms for {item.id}
                      </title>
                    </rect>
                  </React.Fragment>
                ))}
                <text
                  x="99%"
                  y={j * graphLineHeight + graphBarHeight / 2}
                  style={{
                    fontSize: fontSize + 'px',
                    fontFamily: "source-code-pro, Menlo, Monaco, Consolas, 'Courier New', monospace",
                    fill: '#cccccc',
                    textAnchor: 'end',
                    dominantBaseline: 'middle',
                  }}
                >
                  {maxOfSingleList(entries).toFixed(1)} ms
                </text>
              </React.Fragment>
            ))}
          </svg>
          <p style={{ marginTop: '1rem', marginBottom: '0.3rem' }}>Legende</p>
          <svg width="100%" height={legendSvgHeight} style={{ backgroundColor: 'white' }}>
            {ids.map((id, j) => (
              <React.Fragment key={'Legend' + j}>
                <rect
                  x="0"
                  y={j * legendLineHeight}
                  width={legendEntryHeight}
                  height={legendEntryHeight}
                  style={{ fill: colorOf(j) }}
                />
                <text
                  x={1.5 * legendEntryHeight}
                  y={j * legendLineHeight + legendEntryHeight / 2}
                  style={{
                    fontSize: fontSize + 'px',
                    dominantBaseline: 'middle',
                    fontFamily: "source-code-pro, Menlo, Monaco, Consolas, 'Courier New', monospace",
                    fontWeight: 'lighter',
                  }}
                >
                  {id}
                </text>
              </React.Fragment>
            ))}
          </svg>
        </Grid>
      </AppCardBg>
    </Grid>
  );
};

export default StatisticsOverview;
