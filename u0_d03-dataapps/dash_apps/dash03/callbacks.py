from dash import Output, Input
import plotly.express as px
from additional import tips

def make_callbacks(app):
    @app.callback(Output('plot', 'figure'),
        [Input('slider1', 'value')])
    def update_graph(value):
        fig = px.scatter(tips.iloc[1:(value + 1), :],
            x='total_bill', y='tip', title='tips')
        return fig
