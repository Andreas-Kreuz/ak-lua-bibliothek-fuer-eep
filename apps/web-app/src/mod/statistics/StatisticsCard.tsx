import Grid from '@mui/material/Grid';
import AppCardBg from '../../ui/AppCardBg';
import AppCardImg from '../../ui/AppCardImg';
import TimeDesc from './model/TimeDesc';
import useStatisticsData from './useStatisticsData';
import React, { useState } from 'react';

const StatisticsOverview = (props: { title: string; times: TimeDesc[] }) => {
  const { max, list, ids } = useStatisticsData(props.times);
  const [expanded, setExpanded] = useState(false);
  const title = props.title;
  var items = Array(10)
    .fill(0)
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

  return (
    <Grid size={{ xs: 12 }}>
      <AppCardBg title={title + ' (max: ' + scale(list) + ' ms)'} image={'/assets/title-image-simulator.jpg'}>
        <Grid padding={2}>
          <svg width="100%" height={20 * 16} style={{ backgroundColor: 'white' }}>
            {items.map((item, index) => (
              <rect key={index} x="0" y={index * 2 * 16} width={'100%'} height={1.2 * 16} style={{ fill: '#f9f9f9' }} />
            ))}
            {list.map((entries, j) => (
              <React.Fragment key={'Outer' + j}>
                {entries.map((item, i) => (
                  <React.Fragment key={'Inner' + i}>
                    <rect
                      x={scaledValueOf(startXOf(i, entries)) + '%'}
                      y={j * 2 * 16}
                      width={scaledValueOf(item.ms) + '%'}
                      height={1.2 * 16}
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
                  y={(j * 2 + 1) * 16}
                  style={{
                    fontSize: '70%',
                    fontFamily: "source-code-pro, Menlo, Monaco, Consolas, 'Courier New', monospace",
                    fill: '#cccccc',
                    textAnchor: 'end',
                  }}
                >
                  {maxOfSingleList(entries).toFixed(1)} ms
                </text>
              </React.Fragment>
            ))}
          </svg>
          {expanded && (
            <>
              <h4 style={{ marginTop: '1rem' }}>Legende</h4>
              <svg width="100%" height={(ids.length * 2 - 1) * 16} style={{ backgroundColor: 'white' }}>
                {ids.map((id, j) => (
                  <React.Fragment key={'Legend' + j}>
                    <rect x="0" y={j * 2 * 16} width="16" height="16" style={{ fill: colorOf(j) }} />
                    <text
                      x={1.5 * 16}
                      y={(j * 2 + 0.8) * 16}
                      style={{ fontFamily: "source-code-pro, Menlo, Monaco, Consolas, 'Courier New', monospace" }}
                    >
                      {id}
                    </text>
                  </React.Fragment>
                ))}
              </svg>
            </>
          )}
        </Grid>
      </AppCardBg>
    </Grid>
  );
};

export default StatisticsOverview;
