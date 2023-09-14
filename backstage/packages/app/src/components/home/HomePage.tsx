// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

import {
    HomePageToolkit,
    HomePageCompanyLogo,
    HomePageStarredEntities,
    TemplateBackstageLogoIcon,
    WelcomeTitle,
} from '@backstage/plugin-home';

import {Content, Page, Header, InfoCard, ContentHeader} from '@backstage/core-components';
import { HomePageSearchBar } from '@backstage/plugin-search';
import { SearchContextProvider } from '@backstage/plugin-search-react';
import { Grid, makeStyles } from '@material-ui/core';
import React from 'react';
import { CustomerLogoFullTitleLight } from './CustomerLogoFullTitleLight';
import LibraryBooksIcon from '@material-ui/icons/LibraryBooks';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemText from '@material-ui/core/ListItemText';
import ListItemAvatar from '@material-ui/core/ListItemAvatar';
import Avatar from '@material-ui/core/Avatar';
import WorkIcon from '@material-ui/icons/Work';
import BeachAccessIcon from '@material-ui/icons/BeachAccess';
import CameraAltIcon from '@material-ui/icons/CameraAlt';

const useStyles = makeStyles(theme => ({
    searchBar: {
        display: 'flex',
        maxWidth: '60vw',
        backgroundColor: theme.palette.background.paper,
        boxShadow: theme.shadows[1],
        padding: '8px 0',
        borderRadius: '50px',
        margin: 'auto',
    },
    searchBarOutline: {
        borderStyle: 'none',
    },
    backstageHeader: {
       title: {
            color: '#000000'
        }
    },
}));


const useLogoStyles = makeStyles(theme => ({
    container: {
        margin: theme.spacing(5, 0),
    },
    svg: {
        width: '100%',
        height: 100,
    },
    path: {
        fill: '#7df3e1',
    },
}));

const ArchFolderList = () => {
    const styles = makeStyles((theme) => ({
        root: {
            width: '100%',
            maxWidth: 360,
            backgroundColor: theme.palette.background.paper,
        },
    }));
    const classes = styles();

    return (
        <List className={classes.root}>
            <ListItem button component="a" href="https://www.paradigmadigital.com/dev/observabilidad-todo-uno-metricas-logs-trazabilidad/" target="_blank">
                <ListItemAvatar>
                    <Avatar>
                        <CameraAltIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText
                    primary="Observabilidad: OpenTelemetry"/>
            </ListItem>
            <ListItem button component="a" href="https://www.paradigmadigital.com/dev/arquitectura-hexagonal-angular-como-mejorar-estructura-aplicaciones/" target="_blank">
                <ListItemAvatar>
                    <Avatar>
                        <CameraAltIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText
                    primary="Angular: Arquitectura Hexagonal"/>
            </ListItem>
            <ListItem button component="a" href="https://www.paradigmadigital.com/dev/principios-solid-cuales-son-como-ayudan/" target="_blank">
                <ListItemAvatar>
                    <Avatar>
                        <CameraAltIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText
                    primary="Principios SOLID"/>
            </ListItem>
            <ListItem button component="a" href="https://www.paradigmadigital.com/dev/webviews-puente-nativo-operativas-web/" target="_blank">
                <ListItemAvatar>
                    <Avatar>
                        <CameraAltIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText
                    primary="Movilidad: Webview"/>
            </ListItem>
        </List>
    );
}

const GoodPracticesFolderList = () => {
    const styles = makeStyles((theme) => ({
        root: {
            width: '100%',
            maxWidth: 360,
            backgroundColor: theme.palette.background.paper,
        },
    }));
    const classes = styles();

    return (
        <List className={classes.root}>
            <ListItem button component="a" href="https://www.paradigmadigital.com/dev/arquitecturas-eda-en-que-consisten-que-tener-en-cuenta/" target="_blank">
                <ListItemAvatar>
                    <Avatar>
                        <CameraAltIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText
                    primary="Buenas Prácticas de diseño EDA"/>
            </ListItem>
            <ListItem button component="a" href="https://www.youtube.com/watch?v=Jn9bTDq1LF8" target="_blank">
                <ListItemAvatar>
                    <Avatar>
                        <CameraAltIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText
                    primary="Seguridad en Google Cloud"/>
            </ListItem>
            <ListItem button component="a" href="https://www.youtube.com/watch?v=tnlvhGhc7dE" target="_blank">
                <ListItemAvatar>
                    <Avatar>
                        <CameraAltIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText
                    primary="Buenas prácticas AWS Athena"/>
            </ListItem>
            <ListItem button component="a" href="https://www.youtube.com/watch?v=s7Ol3fA69Ns" target="_blank">
                <ListItemAvatar>
                    <Avatar>
                        <CameraAltIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText
                    primary="Buenas prácticas CSS"/>
            </ListItem>

        </List>
    );
}

const HowtoFolderList = () => {
    const styles = makeStyles((theme) => ({
        root: {
            width: '100%',
            maxWidth: 360,
            backgroundColor: theme.palette.background.paper,
        },
    }));
    const classes = styles();

    return (
        <List className={classes.root}>
            <ListItem button component="a" href="https://www.youtube.com/watch?v=G_k639ofEYA" target="_blank">
                <ListItemAvatar>
                    <Avatar>
                        <CameraAltIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText
                    primary="Generator: OpenAPI / AsyncAPI"/>
            </ListItem>
            <ListItem button component="a" href="https://www.paradigmadigital.com/dev/apache-kafka-aws-lambda-condenados-entenderse/" target="_blank">
                <ListItemAvatar>
                    <Avatar>
                        <CameraAltIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText
                    primary="Kafka y AWS Lambda"/>
            </ListItem>
            <ListItem button component="a" href="https://www.paradigmadigital.com/dev/testing-kafka-streams-ksqldb/" target="_blank">
                <ListItemAvatar>
                    <Avatar>
                        <CameraAltIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText
                    primary="Testing Kafka Streams y KSQLDB"/>
            </ListItem>
            <ListItem button component="a" href="https://www.paradigmadigital.com/dev/webviews-puente-nativo-operativas-web/" target="_blank">
                <ListItemAvatar>
                    <Avatar>
                        <CameraAltIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText
                    primary="Uso de Webview"/>
            </ListItem>

        </List>
    );
}

const ExamplesFolderList = () => {
    const styles = makeStyles((theme) => ({
        root: {
            width: '100%',
            maxWidth: 360,
            backgroundColor: theme.palette.background.paper,
        },
    }));
    const classes = styles();

    return (
        <List className={classes.root}>
            <ListItem button component="a" href="https://www.paradigmadigital.com/dev/virtualizacion-contenedores-kubernetes-certificados-tls/" target="_blank">
                <ListItemAvatar>
                    <Avatar>
                        <CameraAltIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText
                    primary="Ejemplo EDA"/>
            </ListItem>
            <ListItem button component="a" href="https://github.com/jaruizes/debezium" target="_blank">
                <ListItemAvatar>
                    <Avatar>
                        <CameraAltIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText
                    primary="Debezium Starter Kit"/>
            </ListItem>
            <ListItem button component="a" href="https://www.paradigmadigital.com/dev/introduccion-arquitectura-microfrontends-ejemplo-react/" target="_blank">
                <ListItemAvatar>
                    <Avatar>
                        <CameraAltIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText
                    primary="Microfronteds React"/>
            </ListItem>
            <ListItem button component="a" href="https://www.paradigmadigital.com/dev/tdd-clave-resolver-kata-mars-rover/" target="_blank">
                <ListItemAvatar>
                    <Avatar>
                        <CameraAltIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText
                    primary="Kata TDD"/>
            </ListItem>

        </List>
    );
}

export const HomePage = () => {
    const classes = useStyles();
    console.log(classes);
    const { container } = useLogoStyles();
    const languages = ['Spanish'];

    return (
        <SearchContextProvider>
            <Page themeId="my-theme">
                <Content>
                    <Grid container justifyContent="center" spacing={6}>
                        <Grid container item xs={12} justifyContent='center'>
                            <HomePageCompanyLogo className={container} logo={<CustomerLogoFullTitleLight />} />

                        </Grid>
                        <Grid container item xs={12} justifyContent='center'>
                            <ContentHeader textAlign='center' title='Tecnología con propósito para mejorar el mundo' />
                        </Grid>
                        <Grid container item xs={8} justifyContent='center'>

                            <HomePageSearchBar
                                classes={{ root: classes.searchBar }}
                                InputProps={{ classes: { notchedOutline: classes.searchBarOutline } }}
                                placeholder="Search"
                            />
                        </Grid>
                        <Grid container item xs={12}>
                            <Grid item xs={12} md={6}>
                                <InfoCard title="Arquitectura">
                                    <ArchFolderList/>
                                </InfoCard>
                            </Grid>
                            <Grid item xs={12} md={6}>
                                <InfoCard title="Buenas prácticas">
                                    <GoodPracticesFolderList/>
                                </InfoCard>
                            </Grid>
                        </Grid>
                        <Grid item xs={12} md={6}>
                            <InfoCard title="How-to">
                                <HowtoFolderList/>
                            </InfoCard>
                        </Grid>
                        <Grid item xs={12} md={6}>
                            <InfoCard title="Ejemplos prácticos">
                                <ExamplesFolderList/>
                            </InfoCard>
                        </Grid>
                    </Grid>
                </Content>
                {/*<Content>*/}
                {/*    <Grid container justifyContent="center" >*/}
                {/*        <Grid container item xs={12} md={5}>*/}
                {/*            */}
                {/*        </Grid>*/}
                
                
                {/*        <Grid container item xs={6} alignItems="center" direction="row">*/}
                {/*            <HomePageSearchBar*/}
                {/*                InputProps={{ classes: { root: classes.searchBarInput, notchedOutline: classes.searchBarOutline }}}*/}
                {/*                placeholder="Search"*/}
                {/*            />*/}
                {/*        </Grid>*/}
                {/*        <Grid container item xs={12}>*/}
                {/*            <Grid item xs={12} md={6}>*/}
                {/*                <HomePageStarredEntities />*/}
                {/*            </Grid>*/}
                {/*            <Grid item xs={12} md={6}>*/}
                {/*                <HomePageToolkit*/}
                {/*                    title="Quick Links"*/}
                {/*                    tools={[*/}
                {/*                        {*/}
                {/*                            url: '/catalog',*/}
                {/*                            label: 'Catalog',*/}
                {/*                            icon: <TemplateBackstageLogoIcon />,*/}
                {/*                        },*/}
                {/*                        {*/}
                {/*                            url: '/docs',*/}
                {/*                            label: 'Tech Docs',*/}
                {/*                            icon: <TemplateBackstageLogoIcon />,*/}
                {/*                        },*/}
                {/*                    ]}*/}
                {/*                />*/}
                {/*            </Grid>*/}
                {/*        </Grid>*/}
                {/*    </Grid>*/}
                {/*</Content>*/}
            </Page>
        </SearchContextProvider>
    );
};
