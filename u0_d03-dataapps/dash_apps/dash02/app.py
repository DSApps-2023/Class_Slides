from dash import Dash, html, dcc
import dash_bootstrap_components as dbc
from additional import *

app = Dash(external_stylesheets=[dbc.themes.BOOTSTRAP])
app.title = 'Wow, what an app.'

SIDEBAR_STYLE = {
    "position": "fixed",
    "top": 0,
    "left": 0,
    "bottom": 0,
    "width": "30rem",
    "padding": "2rem 1rem",
    "background-color": "#f8f9fa",
}

CONTENT_STYLE = {
    "margin-left": "32rem",
    "margin-right": "2rem",
    "padding": "2rem 1rem",
}

sidebar = html.Div(
    [
        html.H1('Wow, what an app'),
        html.Hr(),
        html.Div([
            dbc.Label('Slider options', html_for='slider1'),
            dcc.Slider(
                id='slider1',
                min=1,
                max=50,
                step=0.5,
                value=30,
                marks={i: '{}'.format(i) for i in range(50) if i % 5 == 0}
                ),
                dbc.Button('Update', id='button')
            ],
            id='slider_section'
        ),
        html.Br(),
        html.Div([
            dbc.Label('Write something', html_for='text'),
            dbc.Input(id='text', placeholder='Something', type='text')
            ],
            id='textinput_section'
        ),
        html.Br(),
        html.Div([
            dbc.Label('Choose a single option:'),
            dbc.RadioItems(
                options=[
                    {'label': 'a', 'value': 1},
                    {'label': 'b', 'value': 2},
                    {'label': 'c', 'value': 3},
                ],
                value=2, id='radio'),
            ],
            id='radio_section'
        )
    ],
    style=SIDEBAR_STYLE,
)

checklist = html.Div([
        dbc.Label('Check me:'),
        dbc.Checklist(options=options_list, id='checklist'),
    ])

upload_file = html.Div([
        dbc.Label('Choose a file:'),
        dcc.Upload(dbc.Button('Browse...'), id = 'file')
    ])

select_option = html.Div([
        dbc.Label('Select:'),
        dbc.Select(options=options_list, id='dropdown', value=1),
    ], style={"width": "20%"})

tstyle = {'width': '50%'}

content = html.Div([
        dcc.Tabs(id='tabs', value='tab1', style = tstyle, children=[
            dcc.Tab(label='Tab', value='tab1', style = tstyle,
                children = [checklist, html.Br(), upload_file, html.Br(), select_option]),
            dcc.Tab(label='Tabby', value='tab2', style = tstyle),
            dcc.Tab(label='Tabula', value='tab3', style = tstyle),
        ])
    ],
    id="page-content", style=CONTENT_STYLE)

app.layout = html.Div([sidebar, content])


if __name__ == '__main__':
    app.run_server()
