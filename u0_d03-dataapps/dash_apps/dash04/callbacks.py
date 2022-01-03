from dash import Output, Input, State
import plotly.express as px
from additional import tips
import io
import base64
import pandas as pd

def parse_contents(content):
    content_type, content_string = content.split(',')
    decoded = base64.b64decode(content_string)
    df = pd.read_csv(io.StringIO(decoded.decode('utf-8')))
    return df

def make_callbacks(app):
    @app.callback(Output('col1', 'options'), Output('col2', 'options'),
        Output('col1', 'value'), Output('col2', 'value'),
        [Input('file', 'contents')])
    def update_dropdown(file_content):
        if file_content is not None:
            df = parse_contents(file_content)
            options = [{'label': i, 'value': i} for i in df.columns]
        else:
            options = [{'label': i, 'value': i} for i in tips.columns]
        return options, options, options[0]['value'], options[1]['value']
 
    @app.callback(Output('plot', 'figure'),
        [Input('button', 'n_clicks'), State('slider1', 'value'), State('text', 'value'),
            State('file', 'contents'), State('col1', 'value'), State('col2', 'value')], prevent_initial_call=True)
    def update_graph(n_clicks, slider_value, title, file_content, col1, col2):
        if file_content is not None:
            df = parse_contents(file_content)
            fig = px.scatter(df.iloc[1:(slider_value + 1), :],
                x=col1, y=col2, title=title)
        else:
            fig = px.scatter(tips.iloc[1:(slider_value + 1), :],
                x=col1, y=col2, title=title)
        return fig
    
 