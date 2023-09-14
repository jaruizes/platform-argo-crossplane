import React from 'react';
import { makeStyles } from '@material-ui/core';
import LogoImg from './logo/PRDG_logo_Horizontal_Blue.png';

const useStyles = makeStyles({
  svg: {
    width: '50%',
    height: 'auto',
    margin: 'auto',
    display: 'block',
  },
});
export const CustomerLogoFullTitleLight = () => {
  const classes = useStyles();

  return <img className={classes.svg} src={LogoImg} />;
};
