<template>
	<div id="app">
		<header>
			<h1>Task Manager</h1>
			<button @click="showForm = true" class="btn btn-primary">
				Add New Task
			</button>
		</header>

		<main>
			<TaskList v-if="!showForm" @edit-task="handleEditTask" />
			<TaskForm
				v-else
				:task="selectedTask"
				@task-saved="handleTaskSaved"
				@cancel="handleCancel"
			/>
		</main>
	</div>
</template>

<script>
import TaskList from "./components/TaskList.vue";
import TaskForm from "./components/TaskForm.vue";

export default {
	name: "App",
	components: {
		TaskList,
		TaskForm,
	},
	data() {
		return {
			showForm: false,
			selectedTask: null,
		};
	},
	methods: {
		handleEditTask(task) {
			this.selectedTask = task;
			this.showForm = true;
		},
		handleTaskSaved() {
			this.showForm = false;
			this.selectedTask = null;
		},
		handleCancel() {
			this.showForm = false;
			this.selectedTask = null;
		},
	},
};
</script>

<style>
#app {
	font-family: Avenir, Helvetica, Arial, sans-serif;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	color: #2c3e50;
}

header {
	background-color: #f8f9fa;
	padding: 20px;
	margin-bottom: 20px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

main {
	max-width: 1200px;
	margin: 0 auto;
	padding: 0 20px;
}

.btn {
	padding: 8px 16px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 1rem;
}

.btn-primary {
	background-color: #007bff;
	color: white;
}

.btn-primary:hover {
	background-color: #0056b3;
}
</style>
