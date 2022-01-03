from dash import Dash
import dash_bootstrap_components as dbc
from layout import make_layout
from callbacks import make_callbacks

app = Dash(external_stylesheets=[dbc.themes.BOOTSTRAP])
app.title = 'Wow, what an app.'
app.layout = make_layout()

make_callbacks(app)

if __name__ == '__main__':
    app.run_server()
