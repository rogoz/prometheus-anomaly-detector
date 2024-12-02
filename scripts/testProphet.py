import time

import pandas as pd
from prophet import Prophet
from prophet.plot import plot_plotly, plot_components_plotly, add_changepoints_to_plot

from get_prom_data import prometheus_to_pandas
# TMG ethos13prodgbr9 ns-team-aem-cm-prd-n47554 cm-p3505-e359410

URL_prom_api = "https://thanos-ns-team-aem-thanos.corp.ethos13-prod-gbr9.ethos.adobe.net/api/v1/query"
prom_query = 'usm_object_cpu_utilisation_value{aem_service="cm-p3505-e359410",aem_pod_type="publish"}[60d]'

df = prometheus_to_pandas(URL_prom_api, prom_query, '1h')
m = Prophet(changepoint_prior_scale=0.05).fit(df)
future = m.make_future_dataframe(periods=168, freq='H')
fcst = m.predict(future)
# fig = m.plot(fcst).show()
#fig = m.plot_components(fcst).show()
# plot_plotly(m, forecast).show()
plot_plotly(m, fcst).show()
plot_components_plotly(m, fcst).show()