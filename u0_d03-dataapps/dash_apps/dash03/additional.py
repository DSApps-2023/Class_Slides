import plotly.express as px

options_list = [
                {'label': 'R', 'value': 1},
                {'label': 'Python', 'value': 2},
				{'label': 'Go', 'value': 3},
]

tips = px.data.tips()  # tips is a pandas DataFrame